# Installation
```st
Metacello new
  repository: 'gitlab://gitlab.forge.berger-levrault.com:bl-drit/bl.drit.experiments/software.engineering/software.migration/migration-katalon-playwright:develop/src';
  baseline: 'Katalon';
  onConflict: [ :ex | ex useIncoming ];
  onUpgrade: [ :ex | ex useIncoming ];
  onDowngrade: [ :ex | ex useLoaded ];
  ignoreImage; 
  load
```

# Example
```st
|ktlProject|

ktlProject := nil. 
KTLModel allInstances.

(FileLocator home / 'Development/playwright-exports') createDirectory deleteAll.

importer := KTLModelImporter new.
ktlProject := importer model: KTLModel new; pretreatAndImportsFromFolder: '/Users/nicolashlad/Development/testautoblatm'.


zephyrTags := (ZephyrAPI new testcases: 'ATM') at: #values.

KTLModelExporter new 
	katalonProject: ktlProject;
	exportWithZephyrTags: zephyrTags;
	exportWithLibFolderFromGitLabApi: (GitlabApi new privateToken: 'private-token-forge-api'; hostUrl: 'https://gitlab.forge.berger-levrault.com/api/v4'; repositories );
	exportWithOriginalLines;
	exportWithDebug;
	exportFolder: (FileLocator home / 'Development/playwright-exports/');
	export. 
 

```