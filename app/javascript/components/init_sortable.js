// import Sortable from 'sortablejs';

// const initSortableShelf = () => {
//   const list = document.querySelector('#results-shelf');
//   Sortable.create(list, {
//   animation: 500,
//   swapThreshold: 1,
//   group: "localStorage-example",
//   store: {
//     /**
//      * Get the order of elements. Called once during initialization.
//      * @param   {Sortable}  sortable
//      * @returns {Array}
//      */
//     get: function (sortable) {
//       var order = localStorage.getItem(sortable.options.group.name);
//       return order ? order.split('|') : [];
//     },

//     /**
//      * Save the order of elements. Called onEnd (when the item is dropped).
//      * @param {Sortable}  sortable
//      */
//     set: function (sortable) {
//       var order = sortable.toArray();
//       localStorage.setItem(sortable.options.group.name, order.join('|'));
//     }
//   }
//   });
// };

// const initSortableSpace = () => {
//   const list = document.querySelector('#results-space');
//   Sortable.create(list, {
//   animation: 500,
//   swapThreshold: 1,
//   group: `localStorage-example${list.dataset.sid}`,
//   store: {
//     /**
//      * Get the order of elements. Called once during initialization.
//      * @param   {Sortable}  sortable
//      * @returns {Array}
//      */
//     get: function (sortable) {
//       var order = localStorage.getItem(sortable.options.group.name);
//       return order ? order.split('|') : [];
//     },

//     /**
//      * Save the order of elements. Called onEnd (when the item is dropped).
//      * @param {Sortable}  sortable
//      */
//     set: function (sortable) {
//       var order = sortable.toArray();
//       localStorage.setItem(sortable.options.group.name, order.join('|'));
//     }
//   }
//   });
// };

// export { initSortableShelf, initSortableSpace };
