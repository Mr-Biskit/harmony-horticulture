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
    Intake[] defaultLevels;

    bool public isActive = false;

    constructor() ERC721("Pots", "POT") {}

    /**
     * Minting functionality
     */

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

    function _mintLoop(address _reciever, uint256 _mintAmount) internal {
        require(isActive, "Sale not open");
        for (uint256 i = 0; i < _mintAmount; ) {
            tokenIds.increment();
            uint256 tokenId = tokenIds.current();
            _safeMint(_reciever, tokenId);
            _setDefaultLevels(tokenId);
            unchecked {
                i++;
            }
        }
    }

    /**
     * Accessors
     */

    function setActive(bool _isActive) public onlyOwner {
        isActive = _isActive;
    }

    /**
     * Level Functionalty
     */

    function addLevel(Intake calldata intakeStruct) external onlyOwner {
        _addLevel(intakeStruct);
    }

    function addLevelList(Intake[] calldata intakeStructs) external onlyOwner {
        _addLevelList(intakeStructs);
    }

    function getLevelMetadata(uint64 levelId)
        public
        view
        onlyOwner
        returns (string memory)
    {
        string memory metadata = _metadata[levelId];
        return metadata;
    }

    function getActiveLevels(uint256 tokenId)
        public
        view
        onlyOwner
        returns (uint64[] memory)
    {
        return _activeLevels[tokenId];
    }
}
