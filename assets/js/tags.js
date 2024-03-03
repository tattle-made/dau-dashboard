import { LitElement, css, html } from 'lit';

export class SimpleGreeting extends LitElement {
    static properties = {
        name: {},
        tags: { state: true },
    };

    constructor() {
        super();
        this.name = 'Worlds';
        this.tags = []

    }

    // Render the UI as a function of component state
    render() {
        return html`
            <div>
                <p >Hello, ${this.name}!</p>
                <p>${this.tags}</p>
                <label for="tags">Tags:</label>
                <input type="text" id="tags" name="tags" @change=${this._add_tag}><br><br>
            </div>`;
    }

    _add_tag(tag_event) {
        console.log('here 1', tag_event.target.value)
        let tag = tag_event.target.value
        this.tags = [...this.tags, tag]
    }

    _increment(e) {
        this.count++;
    }
}

export default SimpleGreeting