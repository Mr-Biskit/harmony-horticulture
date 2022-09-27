// SPDX-License-Identifier: MIT

// import "@openzeppelin/contracts/interfaces/IERC165.sol";

pragma solidity ^0.8.15;

interface IBase {
    /**
     * @dev Theme type enum for themes accoisted with NFT
     */
    enum Themes {
        None,
        Africa,
        Mountain,
        Jungle
    }

    /**
     * @dev Level struct for a standard base item.
     */
    struct Level {
        Themes theme;
        uint64 levelRefId;
        string metadataURI;
    }

    /**
     * @dev A intake struct containing the levelId and its associated Level
     */

    struct Intake {
        uint64 levelId;
        Level level;
    }

    /**
     * @dev Returns the level object at reference levelId.
     */
    function getLevel(uint64 levelId) external view returns (Level memory);

    /**
     * @dev Returns the level objects at reference levelIds.
     */
    function getLevels(uint64[] calldata levelIds)
        external
        view
        returns (Level[] memory);
}
