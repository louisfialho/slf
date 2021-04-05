// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 500,
      onEnd: this.end.bind(this)
    })
  }

  end(event) {
    let id = event.item.dataset.id
    let type = event.item.dataset.type
    let data = new FormData()
    data.append("position", event.newIndex + 1)
    data.append("id", id)

    Rails.ajax({
      url: this.data.get("url").replace(':id', id).replace(':type', type),
      type: 'PATCH',
      data: data
    })
  }
}
