/** @format */

import React from "react"
import { newContextComponets } from "@drizzle/react-components"
import TweetList from "./tweet/TweetList"

const { ContractData } = newContextComponets

const MyTweets = () => {
	return (
		<>
			<div>
				<h3>My Tweets</h3>
				<ContractData
					drizzle={drizzle}
					drizzleState={drizzleState}
					contract='Tweeter'
					method='getTweetsOf'
					methodArgs={[drizzleState.accounts[0], 3]}
					render={(tweets) => <TweetList tweets={tweets} />}
				/>
			</div>
		</>
	)
}

export default MyTweets
