// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract nftMarketplace is ERC721URIStorage{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter private _itmesSold;

    uint256 listingprice = 0.0015 ether;

    address payable qwner;

    mapping(uint256 => Marketitem) private idMarketItem;

    struct Marketitem{
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event idMarketItemCreated(
uint256 indexed tokenid,
address seller,
address owner,
uint256 price,
bool sold
 );

   modifier onlyowner{
    require(msg.sender == owner, "only owner of the marketplace can change the listing price")
   };

   _;
    constructor() ERC721("NFT Metavarse Token", "MYNFT"){
        owner == payable(msg.sender);
    }

    function updateListingPrice(uint256 _listingPrice) 
public
payable
onlyOwner{
    listingprice = _listingPrice;
    }
}
function getListingPrice() public view rwturns (uint256){
    return listingPrice;
}

// NFT TOken function

function createToken(string memory tokenURI, uint256 price)public payable returns(uint256){
    _tokenIds.increment(); 

    uint256 newtokenId = _tokenIds.current();

    _mint(msg.sender, newtokenId);
}


