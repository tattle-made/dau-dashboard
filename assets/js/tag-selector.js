// Every media item is tagged exhaustively. The tagging taxonomy is not finalized yet and is expected to change a lot
// in the meanwhile we need an interactive easy to tweak UI system that allows users to choose from a large list (~50 items)
// the chosen tags also need to be sent to the server. 

import { LitElement, html } from 'lit';
import { ref, createRef } from 'lit/directives/ref.js'

export class TagSelector extends LitElement {
    containerRef = createRef()

    static properties = {
        tags: []
    };

    constructor() {
        super();

    }

    connectedCallback() {
        super.connectedCallback()
        console.log('tag selector initialized')
    }

    firstUpdated() {

    }

    render() {
        return html`
            <div>
                tag selector
            </div>`;
    }

    _play() {

    }

}

export default TagSelector