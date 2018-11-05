#if defined td_engine_precaches_includes
  #endinput
#endif
#define td_engine_precaches_includes

public plugin_precache()
{
    @initTries();
    @initArrays();

    loadModelsConfiguration();

    for(new i = 0; i < _:MODELS_ENUM; ++i)
    {
        precache_model(g_Models[MODELS_ENUM:i]);
    }
}

public releaseArrays()
{
    @releaseArrays();
}

@releaseArrays()
{
    @releaseWaveDataArray();
}

@initTries()
{
    @initMapConfigurationTrie();
    @initModelsConfigurationTrie();
    @initWavesConfigurationTrie();
}

@initArrays()
{
    @initWaveDataArray();
}

@initWaveDataArray()
{
    g_WaveDataArray = ArrayCreate();
}

@initModelsConfigurationTrie()
{
    g_ModelsConfigurationKeysTrie = TrieCreate();

    TrieSetCell(g_ModelsConfigurationKeysTrie, "TOWER_MODEL", _:TOWER_MODEL);
    TrieSetCell(g_ModelsConfigurationKeysTrie, "START_SPRITE_MODEL", _:START_SPRITE_MODEL);
    TrieSetCell(g_ModelsConfigurationKeysTrie, "END_SPRITE_MODEL", _:END_SPRITE_MODEL);
}

@initMapConfigurationTrie()
{
    g_MapConfigurationKeysTrie = TrieCreate();

    TrieSetCell(g_MapConfigurationKeysTrie, "SHOW_START_SPRITE", _:SHOW_START_SPRITE);
    TrieSetCell(g_MapConfigurationKeysTrie, "SHOW_END_SPRITE", _:SHOW_END_SPRITE);
    TrieSetCell(g_MapConfigurationKeysTrie, "SHOW_TOWER", _:SHOW_TOWER);
    TrieSetCell(g_MapConfigurationKeysTrie, "TOWER_HEALTH", _:TOWER_HEALTH);
    TrieSetCell(g_MapConfigurationKeysTrie, "SHOW_BLAST_ON_MONSTER_TOUCH", _:SHOW_BLAST_ON_MONSTER_TOUCH);
}

@initWavesConfigurationTrie()
{
    g_MonsterTypesConfigurationKeysTrie = TrieCreate();

    TrieSetCell(g_MonsterTypesConfigurationKeysTrie, "Type", _:TYPE);
    TrieSetCell(g_MonsterTypesConfigurationKeysTrie, "Health", _:HEALTH);
    TrieSetCell(g_MonsterTypesConfigurationKeysTrie, "Speed", _:SPEED);
    TrieSetCell(g_MonsterTypesConfigurationKeysTrie, "DeployInterval", _:DEPLOY_INTERVAL);
    TrieSetCell(g_MonsterTypesConfigurationKeysTrie, "Count", _:COUNT);
    TrieSetCell(g_MonsterTypesConfigurationKeysTrie, "DeployExtraDelay", _:DEPLOY_EXTRA_DELAY);

    g_WavesConfigurationKeysTrie = TrieCreate();

    TrieSetCell(g_WavesConfigurationKeysTrie, "TimeToWave", _:TIME_TO_WAVE);
}

@releaseWaveDataArray()
{
    new size = ArraySize(g_WaveDataArray);

    for(new i = 0; i < size; ++i)
    {
        new Array:waveArray = Array:ArrayGetCell(g_WaveDataArray, i);

        new Trie:waveConfigurationTrie = Trie:ArrayGetCell(waveArray, _:CONFIG);
        new Array:monsterTypesArray = Array:ArrayGetCell(waveArray, _:MONSTER_TYPES);

        new monsterTypesCount = ArraySize(monsterTypesArray);
        for(new j = 0; j < monsterTypesCount; ++j)
        {
            new Trie:monsterTypeTrie = Trie:ArrayGetCell(waveArray, j);
            TrieDestroy(monsterTypeTrie);
        }

        ArrayDestroy(monsterTypesArray);
        TrieDestroy(waveConfigurationTrie);
        ArrayDestroy(waveArray);
    }

    ArrayDestroy(g_WaveDataArray);
}