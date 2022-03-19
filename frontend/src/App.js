/** @format */

import "./App.css"
import { Drizzle } from "@drizzle/store"
import { DrizzleContext } from "@drizzle/react-plugin"

import drizzleOptions from "./utils/drizzleOptions"

import AllTweets from "./components/AllTweets"
import MyTweets from "./components/MyTweets"
import NewTweets from "./components/NewTweets"
import Navbar from "./components/Navbar"

const drizzle = new Drizzle(drizzleOptions)

function App() {
	return (
		<Router>
			<DrizzleContext.Provider drizzle={drizzle}>
				<DrizzleContext.Consumer>
					{(drizzleContext) => {
						const { drizzle, drizzleState, initialized } = drizzleContext
						console.log(drizzle)
						console.log(drizzleState)
						if (!initialized) {
							return "Loading..."
						}
						return (
							<>
								<div className='container'>
									<div className='row'>
										<div className='col-sm-12'>
											<Navbar />
										</div>
									</div>
								</div>
								<div className='row'>
									<div className='col-sm-12'></div>
									<Switch>
										<Route exact path='/' component={AllTweets} />
										<Route path='/my-tweet' component={MyTweets} />
										<Route path='/new-tweet' component={NewTweets} />
									</Switch>
								</div>
							</>
						)
					}}
				</DrizzleContext.Consumer>
			</DrizzleContext.Provider>
		</Router>
	)
}

export default App
