/** @format */

import React from "react"
import { newContextComponents } from "@drizzle/react-components"

const { ContractForm } = newContextComponents

const NewTweets = ({ drizzle }) => {
	;<>
		return (
		<div>
			<h3>New tweet</h3>
			<ContractForm drizzle={drizzle} contract='Tweeter' method='tweet' />
		</div>
		)
	</>
}

export default NewTweets
