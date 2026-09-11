HTMLWidgets.widget({

  name: 'heat_tree',

  type: 'output',

  factory: function(el, width, height) {
    return {

      renderValue: function(x) {
        // Extract trees and options from the data passed from R
        var trees = x.trees || [];
        var options = x.options || {};

        // Call the HeatTree.heatTree function with the selector, trees array, and options
        HeatTree.heatTree(`#${el.id}`, trees, options);
      },

      resize: function(width, height) {
      }

    };
  }
});
