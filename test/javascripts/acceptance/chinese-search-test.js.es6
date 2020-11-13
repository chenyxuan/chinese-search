import { acceptance } from "discourse/tests/helpers/qunit-helpers";

acceptance("chinese-search", { loggedIn: true });

test("chinese-search works", async assert => {
  await visit("/admin/plugins/chinese-search");

  assert.ok(false, "it shows the chinese-search button");
});
