// Vueの導入と、エントリのインポート
import Vue from 'vue';
import App from './App.vue';
import VModal from 'vue-js-modal';
import ActionCable from 'actioncable';

// vue-js-modal の読み込み
Vue.use(VModal);

const cable = ActionCable.createConsumer('ws:localhost:3000/cable');
Vue.prototype.$cable = cable;

// App.vueをエントリとしてレンダリング
new Vue({
  el: '#app',
  render: h => h(App)
})
