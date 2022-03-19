// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Resolver {
    function addr(bytes32 node) external view virtual returns (address);
}

abstract contract ENS {
    function resolver(bytes32 node) external view virtual returns (Resolver);
}

contract Tweeter {
    struct Tweet {
        uint256 id;
        address authorAddress;
        string authorName;
        string content;
        uint256 createdAt;
    }

    struct Message {
        uint256 id;
        string content;
        address from;
        address to;
        uint256 createdAt;
    }

    mapping(uint256 => Tweet) private tweets;
    mapping(address => uint256[]) private tweetsOf;
    mapping(uint256 => Message[]) private conversations;
    mapping(address => address[]) public following;
    mapping(address => mapping(address => bool)) private operators;
    uint256 private nextTweetId;
    uint256 private nextMessageId;
    ENS public ens;

    event TweetSent(
        uint256 id,
        address indexed author,
        string content,
        uint256 createdAt
    );

    event MessageSent(
        uint256 id,
        string content,
        address indexed from,
        address indexed to,
        uint256 createdAt
    );

    constructor(address ensAddress) {
        ens = ENS(ensAddress);
    }

    function resolve(bytes32 _node) public view returns (address) {
        Resolver resolver = ens.resolver(_node);
        return resolver.addr(_node);
    }

    function reverseResolve(address _authorAddress)
        public
        pure
        returns (string memory)
    {
        return "author name";
    }

    function tweet(string calldata _content) external {
        _tweet(msg.sender, _content);
    }

    function tweetFrom(address _from, string calldata _content) external {
        _tweet(_from, _content);
    }

    function sendMessage(string calldata _content, address _to) external {
        _sendMessage(_content, msg.sender, _to);
    }

    function sendMessageFrom(
        string calldata _content,
        address _from,
        address _to
    ) external {
        _sendMessage(_content, _from, _to);
    }

    function follow(address _followed) external {
        following[msg.sender].push(_followed);
    }

    function allow(address _operator) external {
        operators[msg.sender][_operator] = true;
    }

    function disallow(address _operator) external {
        operators[msg.sender][_operator] = false;
    }

    function getLatestTweets(uint256 count)
        external
        view
        returns (Tweet[] memory)
    {
        require(
            count > 0 && count <= nextTweetId,
            "Not enough or too many tweets to return"
        );
        Tweet[] memory _tweets = new Tweet[](count);
        uint256 j;
        for (uint256 i = nextTweetId - count; i < nextTweetId; i++) {
            Tweet storage _tweet = tweets[i];
            _tweets[j] = Tweet(
                _tweet.id,
                _tweet.authorAddress,
                _tweet.authorName,
                _tweet.content,
                _tweet.createdAt
            );
            j += 1;
        }
        return _tweets;
    }

    function getTweetsOf(address _user, uint256 count)
        external
        view
        returns (Tweet[] memory)
    {
        uint256[] storage tweetIds = tweetsOf[_user];
        require(
            count > 0 && count <= tweetIds.length,
            "Too few or many tweets to return"
        );
        Tweet[] memory _tweets = new Tweet[](count);
        uint256 j;
        for (uint256 i = tweetIds.length - count; i < tweetIds.length; i++) {
            Tweet storage _tweet = tweets[tweetIds[i]];
            _tweets[j] = Tweet(
                _tweet.id,
                _tweet.authorAddress,
                _tweet.authorName,
                _tweet.content,
                _tweet.createdAt
            );
            j += 1;
        }
        return _tweets;
    }

    function _tweet(address _authorAddress, string memory _content)
        internal
        canOperate(_authorAddress)
    {
        string memory authorName = reverseResolve(_authorAddress);
        tweets[nextTweetId] = Tweet(
            nextTweetId,
            _authorAddress,
            authorName,
            _content,
            block.timestamp
        );
        tweetsOf[_authorAddress].push(nextTweetId);
        emit TweetSent(nextTweetId, _authorAddress, _content, block.timestamp);
        nextTweetId++;
    }

    function _sendMessage(
        string memory _content,
        address _from,
        address _to
    ) internal canOperate(_from) {
        uint256 conversationId = uint256(uint160(_from)) +
            uint256(uint160(_to));
        conversations[conversationId].push(
            Message(nextMessageId, _content, _from, _to, block.timestamp)
        );
        emit MessageSent(nextMessageId, _content, _from, _to, block.timestamp);
        nextMessageId++;
    }

    modifier canOperate(address _from) {
        require(
            operators[_from][msg.sender] == true,
            "Operator not authorized"
        );
        _;
    }
}
