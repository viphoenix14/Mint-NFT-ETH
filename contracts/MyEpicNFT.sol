// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// // contract MyEpicNFT {
// //     constructor() {
// //         console.log("This is my NFT contract. Whoa!");
// //     }
// // }

// // We inherit the contract we imported. This means we'll have access
// // to the inherited contract's methods.
// contract MyEpicNFT is ERC721URIStorage {
//   // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
//   using Counters for Counters.Counter;
//   Counters.Counter private _tokenIds;

//   // We need to pass the name of our NFTs token and it's symbol.
//   constructor() ERC721 ("PokemonNFT", "PIKACHU") {
//     console.log("This is my NFT contract. Woah!");
//   }

//   // A function our user will hit to get their NFT.
//   function makeAnEpicNFT() public {
//      // Get the current tokenId, this starts at 0.
//     uint256 newItemId = _tokenIds.current();

//      // Actually mint the NFT to the sender using msg.sender.
//     _safeMint(msg.sender, newItemId);

//     // Set the NFTs data.
//     //_setTokenURI(newItemId, "https://jsonkeeper.com/b/4OXH");
//     _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiQ3V0ZUJvdW5jeVNsaW1lIiwKICAgICJkZXNjcmlwdGlvbiI6ICJBbiBORlQgZnJvbSB0aGUgaGlnaGx5IGFjY2xhaW1lZCBzbGltZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStRM1YwWlVKdmRXNWplVk5zYVcxbFBDOTBaWGgwUGdvOEwzTjJaejQ9Igp9");
//     console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

//     // Increment the counter for when the next NFT is minted.
//     _tokenIds.increment();
//   }
// }

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  //string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // We split the SVG at the part where it asks for the background color.
  string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
  string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] firstWords = ["Yummy", "Sticky", "Cute", "Brave", "Lovely", "Excited","Clumsy", "Silly", "Jealous", "Smart", "Grumpy", "Hungry","Sleepy", "Bouncy", "Interesting"];
  string[] secondWords = ["Rimuru", "Ranga", "Souei", "Shion", "Shuna", "Luffy","Benimaru","Nami", "Boa", "Zoro", "Sanji", "Chopper","Veldora", "Ussop", "Robin"];
  string[] thirdWords = ["FrenchFries", "Pizza", "Noodle", "Rice", "Sushi", "Pasta","Soup", "Spagetti", "StirFry", "Burger", "Onigiri", "Bento","Curry", "Mentai", "Sambal"];

  // Get fancy with it! Declare a bunch of colors.
  string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

  int total_minted = 0;
  int max_mint = 3;

  // MAGICAL EVENTS.
  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("PokemonNFT", "PIKACHU") {
    console.log("This is my NFT contract. Woah!");
  }

  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  // Same old stuff, pick a random color.
  function pickRandomColor(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
    rand = rand % colors.length;
    return colors[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    console.log("New Item ID: %s", newItemId);
    
    require(total_minted <= max_mint, "Maximum number of mint reached");

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);

    // // I concatenate it all together, and then close the <text> and <svg> tags.
    // string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));
    // console.log("\n--------------------");
    // console.log(finalSvg);
    // console.log("--------------------\n");

    // _safeMint(msg.sender, newItemId);
  
    // // We'll be setting the tokenURI later!
    // _setTokenURI(newItemId, "blah");

    string memory combinedWord = string(abi.encodePacked(first, second, third));

    // Add the random color in.
    string memory randomColor = pickRandomColor(newItemId);
    string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));
    //string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    //console.log(finalTokenUri);
    console.log(
    string(
        abi.encodePacked(
            "https://nftpreview.0xdev.codes/?code=",
            finalTokenUri
        )
      )
    );
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
  
    console.log("Token ID: %s", _tokenIds.current());

    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    total_minted++;

    // EMIT MAGICAL EVENTS.
    emit NewEpicNFTMinted(msg.sender, newItemId);

    

  }
}