import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "copyLink", "url", "copiedText" ];
  
  copyClicked (event) {
    const url = this.urlTarget.value;
    navigator.clipboard.writeText(url);
    this.copyLinkTarget.classList.add("d-none");
    this.copiedTextTarget.classList.remove("d-none");

    const copyLinkTarget = this.copyLinkTarget;
    const copiedTextTarget = this.copiedTextTarget;

    setTimeout(function() {
      copyLinkTarget.classList.remove("d-none");
      copiedTextTarget.classList.add("d-none");
    }, 1500);

    event.preventDefault();
    event.stopPropgation();
  }
}
