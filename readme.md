# disclaimer
the Playwright exporter requires an typescript librairy that is not part of this project (close-source from Berger-Levrault). 
Typescript code is still outputed, but missing methods errors will occurs when opening the playwright folder.


# Installation
```st
Metacello new
  repository: 'github://github.com:Evref-BL/famix-katalon-studio:master/src';
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
ktlProject := importer model: KTLModel new; pretreatAndImportsFromFolder: '/Development/testKatalon'.

KTLModelExporter new 
	katalonProject: ktlProject;
	exportWithOriginalLines;
	exportWithDebug;
	exportFolder: (FileLocator home / 'Development/playwright-exports/');
	export. 

```
