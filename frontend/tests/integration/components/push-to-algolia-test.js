import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('push-to-algolia', 'Integration | Component | push to algolia', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{push-to-algolia}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#push-to-algolia}}
      template block text
    {{/push-to-algolia}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
