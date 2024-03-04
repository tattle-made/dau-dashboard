import { LitElement, css, html } from 'lit';
import { ref, createRef } from 'lit/directives/ref.js'
import WaveSurfer from 'wavesurfer.js'

export class AudioPlayer extends LitElement {
    containerRef = createRef()

    static properties = {
        url: {}
    };

    constructor() {
        super();

    }

    connectedCallback() {
        super.connectedCallback()
        console.log('hello')
    }

    firstUpdated() {
        const wavesurfer = WaveSurfer.create({
            container: this.containerRef.value,
            waveColor: '#29524A',
            progressColor: '#401F3E',
            url: this.url,
        })

        wavesurfer.on('click', () => {
            wavesurfer.play()
        })
    }

    render() {
        return html`
            <div ${ref(this.containerRef)}>
            
            </div>`;
    }

    _play() {

    }

}

export default AudioPlayer