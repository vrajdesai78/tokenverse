// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Token.sol";

error ONLY_ONWER_CAN_CALL();

contract LaunchPad {

    // LaunchPad contract onwer
    address private launchPadOwner;

    // number of Tokens Created
    uint256 private numOfTokensCreated;

    //
    uint256 private tokenCreationPrice;

    // struct to store all the data of Token and LaunchPad contract
    struct LaunchStruct {
        address launchPadAddress;
        address creator;
        string name;
        string symbol;
        bool wantTotalCap;
        uint totalCap;
        bool wantInitialMint;
        uint initialMint;
        // address[] whiteListAddresses;
    }

    // searching the struct data of Token and LaunchPad using creator address
    mapping(address => LaunchStruct[]) public allData;

    // creator address to check the addresses of token created
    // creator => token addresses
    mapping(address => address[]) public tokenAddresses;

    // modifier to allow onwer to call the function
    modifier onlyOwner() {
        if(msg.sender != launchPadOwner){
            revert ONLY_ONWER_CAN_CALL();
        }
        _;
    }

    /**
     * @dev constructor to get the owner address of this contract factory
     */
    constructor(address _launchPadOwner, uint256 _tokenCreationPrice) {
        launchPadOwner = _launchPadOwner;
        tokenCreationPrice = _tokenCreationPrice;
    }

    /**
     * @dev function to create the contract MultiSigWallet
     */
    function CreateToken(address _creator, string memory _name, string memory _symbol, bool _wantTotalCap, uint _totalCap, bool _wantInitialMint, uint _initialMint/*, address[] memory _whiteListAddresses*/) public {
        // Create a new Wallet contract
        Token token =  new Token(
            _creator,
            _name,
            _symbol,
            _wantTotalCap,
            _totalCap,
            _wantInitialMint,
            _initialMint
            // _whiteListAddresses
        );
        // Increment the number of Tokens Created
        numOfTokensCreated++;

        // Add token data to the mapping
        allData[_creator].push(
            LaunchStruct(
            address(this),
            _creator,
            _name,
            _symbol,
            _wantTotalCap,
            _totalCap,
            _wantInitialMint,
            _initialMint
            // _whiteListAddresses
            )
        );


        // search the profile by using creator address
        // Solidity mappings with array type keys are not a good idea to use in practice, 
        // as the key data is stored in the contract storage and it will consume a lot of storage and gas cost.
        tokenAddresses[_creator].push(address(token));
    }

    function setNewOwner(address _newOnwer) public onlyOwner {
        launchPadOwner = _newOnwer;
    }

    function setNewPrice(uint256 _newTokenCreationPrice) public onlyOwner{
        tokenCreationPrice =  _newTokenCreationPrice;
    }

    


    // get the address of Launchpad contract
    function getAddressOfLaunchpadContract() public view returns (address) {
        return address(this);
    }

    // get the address of Launchpad contract owner
    function getAddressOfLaunchpadOwner() public view returns (address) {
        return launchPadOwner;
    }

    // get all the wallet addresses deployed by creator address
    function getTokensCreatedByCreator(address _creatorAddress) public view returns(address[] memory){
        return tokenAddresses[_creatorAddress];
    }

    function getTotalToken() public view returns(uint){
        return numOfTokensCreated;
    }

    function getTokenCreationPrice() public view returns(uint){
        return tokenCreationPrice;
    }

}