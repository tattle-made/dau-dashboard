let FilterSelectHook = {
  mounted() {
    // Listen for change events on the select element
    this.el.addEventListener("change", (e) => {
      const name = this.el.dataset.name;
      const value = e.target.value;
      this.pushEvent("change-search", { name: name, value: value });
    });
  }
};

export default FilterSelectHook;
