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

	var graph = ui.editor.graph;

    function tidyObject(cell) {

		if (cell.isVertex()) {
			var geo = graph.getCellGeometry(cell);

			if ( geo != null ) {
				geo.x = Math.round(geo.x / 5.0) * 5.0;
				geo.y = Math.round(geo.y / 5.0) * 5.0;
				geo.width = Math.max( 1, Math.round(geo.width / 5.0) * 5.0);
				geo.height = Math.max( 1, Math.round(geo.height / 5.0) * 5.0);
			}
		}
	}

    function tidyAllObjects(cell) {

		tidyObject(cell);

		//if (cell.nodeType == mxConstants.NODETYPE_ELEMENT) {

			var childCount = cell.getChildCount();
			for (var i = 0; i < childCount; i++) {
				tidyAllObjects(cell.getChildAt(i));
			}
		//}
	}

	// Adds action
	ui.actions.addAction('tidyobjects', function()
	{
		var root = graph.getModel().getRoot();

		if (root.getChildCount() > 0)
		{
			graph.getModel().beginUpdate();
			try
			{
				tidyAllObjects(root);
			}
			finally
			{
				graph.getModel().endUpdate();
			}

			ui.saveFile(false);
			ui.alert("All done");
		}
		else
		{
			ui.alert("Empty diagram");
		}
	});


	// Add menu Item under extras
	var menu = ui.menus.get('extras');
	var oldFunct = menu.funct;

	menu.funct = function(menu, parent)
	{
		oldFunct.apply(this, arguments);
		ui.menus.addMenuItems(menu, ['-', 'tidyobjects'], parent);
	};
});