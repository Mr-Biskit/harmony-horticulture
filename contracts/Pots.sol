// SDPX-LICENSE-IDENTIFIER: MIT

import "./Base.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error Pots__InvalidMintAmount();
error Pots__MaxSupplyExceeded();

pragma solidity ^0.8.15;

contract Pots is Base, ERC721, Ownable {
    using Counters for Counters.Counter;

    // Variables
    uint256 private constant MAX_SUPPLY = 5000;
    uint256 private constant MAX_PER_MINT = 2;
    Counters.Counter private tokenIds;
    uint64[] private i_defaultLevelIds;
    uint64[] private i_defaultLevelRefIds;
    string[] private i_defaultMetadataURI;
    Intake[] defaultLevels;

    constructor(
        uint64[] memory _levelIds,
        uint64[] memory _levelrefIds,
        string[] memory _metadataURI
    ) ERC721("Pots", "POT") {
        i_defaultLevelIds = _levelIds;
        i_defaultLevelIds = _levelrefIds;
        i_defaultMetadataURI = _metadataURI;
    }

    modifier mintCompliance(uint256 _mintAmount) {
        require(
            _mintAmount > 0 && _mintAmount <= MAX_PER_MINT,
            "Invalid Mint Amount"
        );
        require(
            tokenIds.current() + _mintAmount <= MAX_SUPPLY,
            "Mx supply exceeded!"
        );
        _;
    }

    function potPlant(uint256 mintAmount) public mintCompliance(mintAmount) {
        if (mintAmount == 0) {
            revert Pots__InvalidMintAmount();
        }
        _mintLoop(msg.sender, mintAmount);
    }

    function createDefaultLevels(
        uint64[] memory _levelIds,
        uint64[] memory _levelrefIds,
        string[] memory _metadataURI
    ) internal onlyOwner {
        defaultLevels = _createDefaultLevels(
            _levelIds,
            _levelrefIds,
            _metadataURI
        );
    }

    function _mintLoop(address _reciever, uint256 _mintAmount) internal {
        for (uint256 i = 0; i < _mintAmount; ) {
            tokenIds.increment();
            uint256 tokenId = tokenIds.current();
            _safeMint(_reciever, tokenId);
            _setDefaultLevels(defaultLevels, tokenId);
            unchecked {
                i++;
            }
        }
    }
}
