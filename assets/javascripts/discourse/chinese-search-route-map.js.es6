export default function() {
  this.route("chinese-search", function() {
    this.route("actions", function() {
      this.route("show", { path: "/:id" });
    });
  });
};
