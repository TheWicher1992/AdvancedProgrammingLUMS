const fs = require(`fs`)
const http = require(`http`)

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
