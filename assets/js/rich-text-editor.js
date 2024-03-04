import { LitElement, html } from 'lit';
import { ref, createRef } from 'lit/directives/ref.js'
import Quill from 'quill'


export class RichTextEditor extends LitElement {
    containerRef = createRef()

    static properties = {
    };

    constructor() {
        super();

    }

    firstUpdated() {
        this.init();
    }

    init() {
        let selector = this.shadowRoot.querySelector('#editor-container');
        this.quill = new Quill(selector, {
            placeholder: 'Compose an epic...',
            theme: 'snow'
        });

        // this._load()
    }


    render() {
        return html`
            <link rel='stylesheet' href='http://cdn.quilljs.com/1.3.6/quill.snow.css'>        
            
            <div id="editor-container"></div>
            <button @click=${this._save}>Save</button>
        `;
    }

    _save() {
        console.log('saved')
        let text = this.quill.root.innerHTML.trim()
        console.log(text)
    }

    _load() {
        let text = `<p>Hello world</p><p><br></p><p><strong>two four six</strong></p><p><br></p><p>link goes h<a href="https://google.com" rel="noopener noreferrer" target="_blank">ere</a></p>`
        this.quill.root.innerHTML = text
    }

}

export default RichTextEditor