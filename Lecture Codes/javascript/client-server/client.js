const CityTemp = () => {
    const appid = `---ADD-APPID-HERE---`
    const [city, setCity] = React.useState(``)
    const [temp, setTemp] = React.useState(0)

    const formSubmit = async (ev) => {
        ev.preventDefault()
        const resp = await fetch(`http://api.openweathermap.org/data/2.5/weather?units=metric&q=${city}&appid=${appid}`)
        const weatherData = await resp.json()
        console.log(weatherData)
        setTemp(weatherData.main.temp)
    }
    
    const cityChange = (ev) => {
        setCity(ev.target.value)
    }
    
    // return (
    //     e(`form`, {onSubmit: formSubmit},
    //         e(`input`, {type: `text`, onChange: cityChange}),
    //         e(`input`, {type: `submit`}),
    //         e(`h2`, null, `T: ${temp}`))
    // )
    return (
        <form onSubmit={formSubmit}>
            <input type='text' onChange={cityChange} />
            <input type='submit' />
            <h2>T: {temp}</h2>
        </form>
    )
}

const App = () => {
    return (
        <div>
            <CityTemp />
            <CityTemp />
            <CityTemp />
        </div>
    )
}

ReactDOM.render(<App />, document.querySelector(`#root`))
