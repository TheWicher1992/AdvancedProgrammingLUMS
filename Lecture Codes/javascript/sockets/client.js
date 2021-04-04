const ws = new WebSocket(`ws://localhost:8080`)

const Chat = () => {
    const [message, setMessage] = React.useState(``)
    const [messageList, setMessageList] = React.useState([])

    ws.onmessage = (event) => {
        const clientMessage = JSON.parse(event.data)
        if (clientMessage.type === `message`) {
            setMessageList([
                ...messageList,
                `${clientMessage.username} says: ${clientMessage.data}`
            ])
        }
    }

    const formSubmit = async (ev) => {
        ev.preventDefault()
        const clientMessage = {
            type: `message`,
            data: message,
            username: `thisuser`,
        }
        ws.send(JSON.stringify(clientMessage))
        setMessage(``)
    }
    
    const messageChange = (ev) => {
        setMessage(ev.target.value)
    }
    
    return (
        <form onSubmit={formSubmit}>
            <input type='text' value={message} onChange={messageChange} />
            <input type='submit' />
            {
                messageList.map((message, index) => (
                    <h2 key={index}>{message}</h2>
                ))
            }
        </form>
    )
}

ReactDOM.render(<Chat />, document.querySelector(`#root`))
