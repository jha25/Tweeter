/** @format */

import React from "react"
import { newContextComponents } from "@drizzle/react-components"
import TweetList from "./tweet/TweetList"

const { ContractData } = newContextComponents
e
const AllTweets = ({ drizzle, drizzleState }) => {
	return (
		<>
			<div>
				<h3>All tweets</h3>
				<ContractData
					drizzle={drizzle}
					drizzleState={drizzleState}
					contract='Tweeter'
					method='getLatestTweets'
					methodArgs={[5]}
					render={(tweets) => <TweetList tweets={tweets} />}
				/>
			</div>
		</>
	)
}

export default AllTweets
