const fs = require(`fs`)
const http = require(`http`)
const WebSocket = require(`ws`)  // npm i ws

const readFile = (fileName) =>
  new Promise((resolve, reject) => {
    fs.readFile(fileName, `utf-8`, (readErr, fileContents) => {
      if (readErr) {
        reject(readErr)
      } else {
        resolve(fileContents)
      }
    })
  })

const delay = (seconds) =>
  new Promise((resolve) => setTimeout(resolve, seconds * 1000))

const server = http.createServer(async (req, resp) => {
  console.log(`browser asked for ${req.url}`)
  if (req.url == `/mydoc`) {
    const clientHtml = await readFile(`client.html`)
    resp.end(clientHtml)
  } else if (req.url == `/myjs`) {
    const clientJs = await readFile(`client.js`)
    resp.end(clientJs)
  } else {
    resp.end(`Not found`)
  }
})

server.listen(8000)

const wss = new WebSocket.Server({ port: 8080 })
let currBoardIndex = 0;
let wordDictionary = [];
let playerScoreMap = new WeakMap()
const players = []
let change = false
let timeLeft = 60
const scoreMap = {
  'A': 2,
  'B': 5,
  'C': 3,
  'D': 3,
  'E': 1,
  'F': 5,
  'G': 4,
  'H': 4,
  'I': 2, 'J': 10, 'K': 6,
  'L': 3, 'M': 4, 'N': 2,
  'O': 2, 'P': 4, 'Q': 8,
  'R': 2, 'S': 2, 'T': 2, 'U': 4, 'V': 6, 'W': 6, 'X': 9, 'Y': 5, 'Z': 8
}
let gridString = ''

let leaderBoard = []
let wordBoards = []

const getDictionary = async () => {
  let file = await readFile('dictionary.txt')
  file = file.split('\n')
  wordDictionary = file
}

const timer = async (seconds) => {
  timeLeft = seconds
  if (seconds === 0) {
    timer(60)
    return
  }
  await delay(1)
  timer(seconds - 1)
}

getDictionary()

const getBoard = async () => {
  let file = await readFile('board.txt')
  file = file.split('\n')

  wordBoards = file.map(word => word.replace('\r', ''))
  if (wordBoards.indexOf('') > -1) {
    wordBoards.splice(wordBoards.indexOf(''), 1)
  }
  gridString = wordBoards[0].toUpperCase()
  console.log(wordBoards)
}

getBoard()



const score = (word) => {
  let tot = 0
  for (let i = 0; i < word.length; i++) {
    const letter = word[i];
    tot += scoreMap[letter]
  }
  return tot
}


const parse = (message) => {
  return JSON.parse(message)
}

const send = (ws, message) => {
  ws.send(JSON.stringify(message))
}

const checkForDuplicates = (arr) => {
  for (let i = 0; i < arr.length; i++) {
    const elem = arr[i]
    for (let j = i + 1; j < arr.length; j++) {
      if (arr[j][0] === elem[0] && arr[j][1] === elem[1]) {
        console.log(arr[j][0], elem[0], arr[j][1], elem[1])
        return true
      }
    }

  }
  return false;
}

const compareBoards = (newBoard) => {
  if (newBoard.length !== leaderBoard.length) {
    return true
  }
  for (let i = 0; i < leaderBoard.length; i++) {
    const e1 = leaderBoard[i];
    const e2 = newBoard[i]

    if (e1.username !== e2.username || e1.score !== e2.score) {
      return true
    }

  }
  return false
}


const sendLeaderBoard = async () => {

  await delay(1)
  if (change) {

    players.forEach(p => send(p, {
      type: 'leaderboard',
      value: leaderBoard
    }))
  }
  change = false
  sendLeaderBoard()
}

const sendGrid = async () => {

  await delay(60)
  let totalBoards = wordBoards.length
  gridString = wordBoards[(currBoardIndex + 1) % totalBoards].toUpperCase()
  players.forEach(p => {
    send(p, {
      type: 'newGrid',
      value: gridString,
      time: 60
    })

    playerScoreMap.set(p, 0)
  }
  )
  currBoardIndex += 1
  leaderBoard = []
  change = true
  sendGrid()
}


const checkAdjacency = (c1, c2) => {
  //non diagonals
  if (c1[0] - 1 === c2[0] && c1[1] === c2[1]) {
    return true
  }
  if (c1[0] + 1 === c2[0] && c1[1] === c2[1]) {
    return true

  }
  if (c1[1] - 1 === c2[1] && c1[0] === c2[0]) {
    return true

  }
  if (c1[1] + 1 === c2[1] && c1[0] === c2[0]) {
    return true

  }
  //diagonals
  if (c1[0] - 1 === c2[0] && c1[1] - 1 === c2[1]) {
    return true
  }
  if (c1[0] - 1 === c2[0] && c1[1] + 1 === c2[1]) {
    return true

  }
  if (c1[1] + 1 === c2[1] && c1[0] - 1 === c2[0]) {
    return true

  }
  if (c1[1] + 1 === c2[1] && c1[0] + 1 === c2[0]) {
    return true

  }

  return false
}


const verifyAdjacency = (arr) => {
  for (let i = 0; i < arr.length - 1; i++) {

    if (!checkAdjacency(arr[i], arr[i + 1])) {
      return false;
    }

  }
  return true
}

const handle = (ws) => {
  ws.on(`message`, (message) => {
    const msg = parse(message)
    console.log(msg)
    if (msg.type === 'username') {
      players.push(ws)
      change = true
      playerScoreMap.set(ws, 0)
      ws.username = msg.value
      send(ws, {
        type: 'newGrid',
        value: gridString,
        time: timeLeft
      })
    }

    if (msg.type === 'mousedown') {
      const letter = msg.value
      send(ws, {
        type: 'serverMessage',
        value: `${ws.username} clicked the letter ${letter}`
      })
    }

    if (msg.type === 'word') {
      const letterIndex = msg.value
      let word = ''
      let count = 0
      letterIndex.forEach(li => {
        count = ((4 * li[0]) + li[1])
        console.log(count)
        word = word + gridString[count]
      })

      if (letterIndex.length <= 2 || checkForDuplicates(letterIndex) || !verifyAdjacency(letterIndex)) {
        console.log('adj', verifyAdjacency(letterIndex))
        send(ws,
          {
            type: 'wordError',
            value: word
          })
      }
      else if (!wordDictionary.includes(word.toLowerCase())) {
        send(ws,
          {
            type: 'dictError',
            value: word
          })
      }
      else {
        console.log(word)
        let currScore = playerScoreMap.get(ws)
        let wordScore = score(word)
        let totalScore = wordScore + currScore
        playerScoreMap.set(ws, totalScore)
        //calculating leaderboard
        let scores = []
        players.forEach(player => {
          scores.push({
            'username': player.username,
            'score': playerScoreMap.get(player)
          })
        })

        scores.sort((a, b) => {
          return b.score - a.score
        })

        scores = scores.splice(0, 3)

        console.log(compareBoards(scores))
        change = compareBoards(scores)
        if (change) {
          leaderBoard = [...scores]
        }

        console.log(scores)

        send(ws,
          {
            type: 'word',
            value: word,
            score: wordScore,
            totalScore: totalScore
          })
      }

    }
    console.log(ws.username)
  })
}






wss.on(`connection`, (ws) => {
  console.log(`A user connected`)

  handle(ws)

})
timer(60)
sendGrid()
sendLeaderBoard()

// while (1) {
//   delay(1).then(
//     players.forEach(ws => send(ws, {
//       type: 'leaderboard',
//       value: leaderBoard
//     }))
//   )
// }