// SPDX-LICENSE-IDENTIFIER: MIT

import "./IBase.sol";

error Base__LevelAlreadyExcists();
error Base__BadConfig();
error Base__LevelInputNotNone();

pragma solidity ^0.8.15;

contract Base is IBase {
    // Array of all the level Ids
    uint64[] internal _allLevelIds;

    // Array of the dafault Levels
    Intake[] internal _defaultLevels;

    // Mapping of tokenId to activeLevels
    mapping(uint256 => uint64[]) internal _activeLevels;

    // Mapping of levelId to levelMetadata
    mapping(uint64 => string) internal _metadata;

    // Mapping of levelId to Levels
    mapping(uint64 => Level) internal _levels;

    //Mapping of levelRefId to nested mapping levelId to Level
    mapping(uint64 => mapping(uint64 => Level)) private _levelRefIds;

    //Mapping of tokenId to new levelId, to levelId to be replaced
    mapping(uint64 => mapping(uint64 => uint64)) private _levelOverwrites;

    /**
     * @dev Private function which writes a single base item entry to storage
     * @param levelIntake struct of type Intake, which consists of levelId and a nested level struct
     */
    function _addLevel(Intake calldata levelIntake) internal {
        if (levelIntake.levelId > 0 && levelIntake.levelId <= 3) {
            _defaultLevels.push(levelIntake);
        }
        uint64 levelId = levelIntake.levelId;
        Level memory level = levelIntake.level;

        _allLevelIds.push(levelId);
        _metadata[levelId] = level.metadataURI;
        _levels[levelId] = level;
        _levelRefIds[level.levelRefId][levelId] = level;
    }

    function _addLevelList(Intake[] calldata levelIntake) internal {
        uint256 len = levelIntake.length;
        for (uint256 i = 0; i < len; ) {
            _addLevel(levelIntake[i]);
            unchecked {
                ++i;
            }
        }
    }

    // function _assignDefaultLevels(Intake[] calldata levelIntake) internal {
    //     _addLevelList(levelIntake);
    //     defaultLevels = levelIntake;
    // }

    function _setDefaultLevels(uint256 tokenId) internal {
        uint256 len = _defaultLevels.length;
        for (uint256 i = 0; i < len; ) {
            uint64 levelId = _defaultLevels[i].levelId;
            if (_defaultLevels[i].level.theme != Themes.None)
                revert Base__LevelInputNotNone();
            _activeLevels[tokenId].push(levelId);
            unchecked {
                i++;
            }
        }
    }

    function getLevel(uint64 levelId) external view returns (Level memory) {
        return (_levels[levelId]);
    }

    function getLevels(uint64[] calldata levelIds)
        external
        view
        returns (Level[] memory)
    {
        uint256 numLevels = levelIds.length;
        Level[] memory levels = new Level[](numLevels);

        for (uint256 i; i < numLevels; ) {
            uint64 levelId = levelIds[i];
            levels[i] = _levels[levelId];
            unchecked {
                ++i;
            }
        }
        return levels;
    }

    function getDefault() public view returns (Intake[] memory) {
        return _defaultLevels;
    }
}
