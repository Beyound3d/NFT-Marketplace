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
    require(msg.sender == owner, "only owner of the marketplace can change the listing price");
   };         
   
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

    _mint(msg.sender, newTokenId);
    _setTokenURI(newTokenId,tokenURI);

    createMarketItem(newTokenId,price);

    return newTokenId;
}

// creating market items

function createMarketItem(int256 tokenId ,uint256 price) private{
require(price > 0,"Price must be atleast 1");
require(
    msg.value == listingPrice,
    "Price must be equal to Listing price"
);


_transfer(msg.sender,address(this),tokenId);

emit idMarketItemCreated(
    tokenId,
    msg.sender,
    address(this),
    price,
    false
);

_transfer(msg.sender,address(this),tokenId);

emit idMarketItemCreated(tokenId,msg.seller,address(this),price,false);

}
//function for resale token
function resellToken(uint256 tokenId,uint256 price)public payable{
    require(idMarketItem[tokenId].owner == msg.sender,"Only item owner can perform this operation");

    require(msg.value == listingPrice,"Price must be equal to listing price");

    idMarketItem[tokenId].sold = false;
    idMarketItem[tokenId].price = price;
    idMarketItem[tokenId].seller = payable(msg.sender);
    idMarketItem[tokenId].owner = payable(address(this));

    _itmesSold.decrement();

    _transfer(msg.sender,address(this),tokenId);
}

//function creating marketsale

function createMarketSale(uint256 tokenId)public payable{
    uint256 price = idMarketItem[tokenId].price;

    require (msg.value == price, "please submit the asking price in order to complete the purchase");
}
   idMarketItem[tokenId].owner = payable(msg.sender);
   idMarketItem[tokenId].sold = true;
   idMarketItem[tokenId].sold = payable(address(0));

   _itemsSold.increment();

   _transfer(address(this),msg.sender,tokenId);

   payable(owner).transfer(listingPrice);
   payable(idMarketItem[tokenId].seller).transfer(msg.value);

// getting sold nft data
function fetchMarketItem() public view returns(MarketItem[] memory){
    uint256 itemCount = _tokenIds.current();
    uint256 unSoldItemCount = _tokenIds.current(); -  _itemsSold.current();
    uint256 currentIndex = 0;

    MarketItem[] memory items =new MarketItem[](unSoldItemCount);

    for (uint256 i =0; i< itemCount; i ++){
        if(idMarketItem[i+1].owner == address(this)){
            uint256 currentId = i + 1;

            MarketItem storage currentItem = idMarketItem[currentId];
            items[currentIndex] = currentItem;
            currentIndex +=1;
        }
    }
    return items;
}
    // purchase item
    function fetchMyNFT() public view returns(MarketItem[]memory){
        uint256 totalCount = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex =0;

        for(uint256 i=0; i< totalCount; i++){
            if(idMarketItem[i + 1].owner == msg.sender){
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for(uint256 i =0; i< totalcount; i++){

            if(idMarketItem[i+1].owner == msg.sender){
            uint256 currentId = i + 1;
            MarketItem storage currentItem = idMarketitem[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;
            }
           
        }
        return items;
    }
// singular user items
function fetchMarketListed() public view returns (MarketItem[] memory){
    uint256 totalCount = _tokenIds.current();
    uint256 itemcount =0;
    uint256 currentIndex =0;

    for(uint256 i =0 ; i <totalCount; i++){
        if(idMarketItem[i+1].seller == msg.sender){
            itemcount +=1;
        }
    }
    MarketItem[] memory items = new MarketItem[](itemCount);
    for(uint256 i = 0; i < totalCount; i++){
        if(idMarketItem[i+1].seller == msg.sender){
            uint256 currentId = i +1;

            MarketItem storage currentItem = idMarketItem[currentId];
            items[currentIndex] =currentItem;
            currentIndex += 1;
        }
    }
    return items;
}

}