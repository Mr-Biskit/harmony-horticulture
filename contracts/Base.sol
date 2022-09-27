// SPDX-LICENSE-IDENTIFIER: MIT

import "./IBase.sol";

error Base__LevelAlreadyExcists();
error Base__BadConfig();
error Base__LevelInputNotNone();

pragma solidity ^0.8.15;

contract Base is IBase {
    // Array of all the level Ids
    uint64[] private _allLevelIds;

    // Array of the dafault Levels
    Intake[] _defaultLevels;

    // Mapping of tokenId to activeLevels
    mapping(uint256 => uint64[]) private _activeLevels;

    // Mapping of levelId to levelMetadata
    mapping(uint64 => string) private _metadata;

    // Mapping of levelId to Levels
    mapping(uint64 => Level) private _levels;

    //Mapping of levelRefId to nested mapping levelId to Level
    mapping(uint64 => mapping(uint64 => Level)) private _levelRefIds;

    //Mapping of tokenId to new levelId, to levelId to be replaced
    mapping(uint64 => mapping(uint64 => uint64)) private _levelOverwrites;

    /**
     * @dev Private function which writes a single base item entry to storage
     * @param levelIntake struct of type Intake, which consists of levelId and a nested level struct
     */
    function _addLevel(Intake memory levelIntake) internal {
        uint64 levelId = levelIntake.levelId;
        Level memory level = levelIntake.level;

        _allLevelIds.push(levelId);
        _metadata[levelId] = level.metadataURI;
        _levels[levelId] = level;
        _levelRefIds[level.levelRefId][levelId] = level;
    }

    function _addLevelList(Intake[] memory levelIntake) internal {
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

    function _setDefaultLevels(Intake[] memory levelIntake, uint256 tokenId)
        internal
    {
        _addLevelList(levelIntake);
        uint256 len = levelIntake.length;
        for (uint256 i = 0; i < len; ) {
            Intake memory level = levelIntake[i];
            uint64 levelId = level.levelId;
            if (level.level.theme == Themes.None)
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

    function _createDefaultLevels(
        uint64[] memory _levelIds,
        uint64[] memory _levelrefIds,
        string[] memory _metadataURI
    ) internal returns (Intake[] memory) {
        for (uint256 i = 0; i < _levelIds.length; i++) {
            uint64 levelId = _levelIds[i];
            uint64 levelrefId = _levelrefIds[i];
            string memory metadataURI = _metadataURI[i];
            Level memory level;
            level.theme = Themes.None;
            level.levelRefId = levelrefId;
            level.metadataURI = metadataURI;
            Intake memory intake;
            intake.levelId = levelId;
            intake.level = level;
            _addLevel(intake);
            _defaultLevels.push(intake);
        }
        return _defaultLevels;
    }
}
