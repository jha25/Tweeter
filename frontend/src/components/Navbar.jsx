/** @format */

import React from "react"
import { useLocation } from "react-router"
import { Link } from "react-router-dom"

const Navbar = ({ navigation }) => {
	const location = useLocation()

	const isActive = (route) => (location.pathname === route ? "active" : "")
	return (
		<nav classname='navbar navbar-expand-lg navbar-light bg-light'>
			<Link className='navbar-brand' to='/'>
				Decentralized Tweeter
			</Link>
			<button
				className='navbar-toggler'
				type='button'
				data-toggle='collapse'
				data-target='#navbarSupportedContent'>
				<span className='navbar-toggler-icon'></span>
			</button>

			<div className='collapse navbar-collapse' id='navbarSupportedContent'>
				<ul className='navbar-nav mr-auto'>
					<li className={`nav-item ${isActive("/")}`}>
						<Link className='nav-link' to='/'>
							Home
						</Link>
					</li>
					<li className={`nav-item ${isActive("/my-tweets")}`}>
						<Link className='nav-link' to='/my-tweets'>
							My Tweets
						</Link>
					</li>
					<li className={`nav-item ${isActive("/new-tweet")}`}>
						<Link className='nav-link' to='/new-tweets'>
							Tweet
						</Link>
					</li>
				</ul>
			</div>
		</nav>
	)
}

export default Navbar
