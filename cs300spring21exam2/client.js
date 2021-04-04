const ws = new WebSocket(`ws://localhost:8080`)

const delay = (seconds) =>
    new Promise((resolve) => setTimeout(resolve, seconds * 1000))

const Wordament = () => {
    const [color, setColor] = React.useState({})
    const [grid, setGrid] = React.useState([])
    const [username, setUsername] = React.useState('')
    const [messageList, setMessageList] = React.useState([])
    const [movementIndex, setMovementIndex] = React.useState([])
    const [buttonChain, setButtonChain] = React.useState([])
    const [down, setDown] = React.useState(false)
    const [totalScore, setTotalScore] = React.useState(0)
    const [topScores, setTopScores] = React.useState([])
    const [time, setTime] = React.useState(0)
    const [boardNumber, setBoardNumber] = React.useState(-1)
    const [cont, setCont] = React.useState(false)

    const delay = (seconds) =>
        new Promise((resolve) => setTimeout(resolve, seconds * 1000))

    const timer = async (seconds) => {
        await delay(1)

        setTime(seconds)
        if (seconds === 0 || cont) {
            setCont(false)
            timer(60)
            return
        }
        timer(seconds - 1)
    }

    ws.onmessage = (event) => {
        console.log(`received: ${event.data}`)
        const action = JSON.parse(event.data)
        if (action.type === 'newGrid') {
            setBoardNumber(boardNumber + 1)
            const row1 = action.value.slice(0, 4)
            const row2 = action.value.slice(4, 8)
            const row3 = action.value.slice(8, 12)
            const row4 = action.value.slice(12, 16)
            setGrid([
                [...row1], [...row2], [...row3], [...row4]
            ])
            setCont(true)
            console.log(row1, row2, row3, row4)
            setTotalScore(0)
            if (boardNumber === -1) {
                timer(action.time)
            }

        }
        if (action.type === 'serverMessage') {
            const sMsg = action.value
            setMessageList([
                ...messageList, sMsg
            ])
        }
        if (action.type === 'word') {
            const sMsg = action.value
            const score = action.score
            setTotalScore(action.totalScore)
            setMessageList([
                ...messageList, `Word ${sMsg} scored ${score} points`
            ])
        }
        if (action.type === 'wordError') {
            const sMsg = action.value
            setMessageList([
                ...messageList, `Word ${sMsg} was not accepted by the server`
            ])
        }
        if (action.type === 'dictError') {
            const sMsg = action.value
            setMessageList([
                ...messageList, `Word ${sMsg} is not a dictionary word`
            ])
        }
        if (action.type === 'leaderboard') {
            setTopScores(action.value)
        }
    }

    const onMouseDown = (letter, e, i, j) => {
        e.target.style.backgroundColor = 'green'
        setMovementIndex([
            ...movementIndex,
            [i, j]
        ])
        setButtonChain([
            ...buttonChain, e
        ])
        setDown(true)
        const payload = {
            type: 'mousedown',
            value: letter
        }
        ws.send(JSON.stringify(payload))

    }

    const onMouseUp = () => {
        setDown(false)

        buttonChain.forEach(e =>
            e.target.style.backgroundColor = ''
        )
        console.log(movementIndex)

        const payload = {
            type: 'word',
            value: movementIndex
        }
        ws.send(JSON.stringify(payload))
        setMovementIndex([])
    }

    const onMouseEnter = (e, i, j) => {
        if (down) {
            console.log('mv', movementIndex)
            if (movementIndex.length >= 2) {
                const secondLastMove = movementIndex[movementIndex.length - 2]
                // console.log([i, j], movementIndex[movementIndex.length - 2])
                if (i === secondLastMove[0] && j === secondLastMove[1]) {
                    const lastMove = movementIndex[movementIndex.length - 1]
                    console.log(lastMove, movementIndex)
                    const rm = movementIndex.splice(0, movementIndex.length - 1)
                    setMovementIndex([
                        ...rm
                    ])
                    buttonChain[buttonChain.length - 1].target.style.backgroundColor = ''
                    console.log('del', rm)
                    console.log('done')
                    return
                }
            }

            e.target.style.backgroundColor = 'green'
            setMovementIndex([
                ...movementIndex,
                [i, j]
            ])
            setButtonChain([
                ...buttonChain, e
            ])
        }
    }

    // const onMouseLeave = (e) => {
    //     if (down) {
    //         e.target.style.backgroundColor = 'green'
    //     }

    // }

    const onSubmit = (event) => {
        event.preventDefault()
        const payload = {
            type: 'username',
            value: username
        }

        console.log(payload)
        ws.send(JSON.stringify(payload))

    }

    const onChange = (event) => {
        console.log(event.target.value)
        setUsername(event.target.value)
    }



    return (
        <div>
            <form onSubmit={onSubmit}>
                <input type='text' onChange={onChange}></input>
                <input title='Connect' type='submit'></input>
            </form>
            <h3>{username} Total Score: {totalScore}</h3>
            <h4>Time Left for this Board: {time}</h4>
            <div>
                <h4>Top scores</h4>
                <ol>
                    {
                        topScores.map((s, i) => <li key={i}>{s.username}:{s.score}</li>)
                    }
                </ol>
            </div>

            {
                grid.map((row, i) => <div key={i}>
                    {
                        row.map((letter, j) =>
                            <button

                                // onMouseLeave={(e) => onMouseLeave(e, i, j)}
                                onMouseEnter={(e) => onMouseEnter(e, i, j)}
                                onMouseUp={(e) => onMouseUp(e, i, j)}
                                onMouseDown={(e) => onMouseDown(letter, e, i, j)}
                                key={j}>{letter}
                            </button>
                        )
                    }
                </div>)
            }


            <div>
                {messageList.map((msg, i) => <div key={i}>{msg}</div>)}
            </div>
        </div>
    )
}

ReactDOM.render(<Wordament />, document.querySelector(`#root`))

