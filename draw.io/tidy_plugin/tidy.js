/**
 * Draw.io Plugin to all objects
 *
 * LOAD Plugin from git:
 *
 * https://XXXX.githubXXXXX.com/xxxxxxxx/draw-io-tidy/master/tidy.js
 */
 Draw.loadPlugin(function (ui) {

	// Adds resource for action
	mxResources.parse('tidyobjects=Tidy Objects');

	const graph = ui.editor.graph;

    function tidyObject(cell) {

		if (! cell.isVertex()) {
            return;
        }

        const geo = graph.getCellGeometry(cell);
        if ( geo == null ) {
            return;
        }

        geo.x = Math.round(geo.x / 5.0) * 5.0;
        geo.y = Math.round(geo.y / 5.0) * 5.0;
        geo.width = Math.max( 1, Math.round(geo.width / 5.0) * 5.0);
        geo.height = Math.max( 1, Math.round(geo.height / 5.0) * 5.0);        
	}

    function tidyAllObjects(cell) {

		tidyObject(cell);

		//if (cell.nodeType == mxConstants.NODETYPE_ELEMENT) {

			const childCount = cell.getChildCount();
			for (let i = 0; i < childCount; i++) {
				tidyAllObjects(cell.getChildAt(i));
			}
		//}
	}

	// Adds action
	ui.actions.addAction('tidyobjects', function()	{
		const root = graph.getModel().getRoot();

		if (root.getChildCount() == 0) {
			ui.alert("Empty diagram");
            return;
		}

        graph.getModel().beginUpdate();
        try {
            tidyAllObjects(root);
        } finally {
            graph.getModel().endUpdate();
        }

        ui.saveFile(false);
        ui.alert("All done");
	});

	// Add menu Item under extras
	const menu = ui.menus.get('extras');
	const oldFunct = menu.funct;

	menu.funct = function(menu, parent)	{
		oldFunct.apply(this, arguments);
		ui.menus.addMenuItems(menu, ['-', 'tidyobjects'], parent);
	};
});