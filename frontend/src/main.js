// Vueの導入と、エントリのインポート
import Vue from 'vue';
import App from './App.vue';
import VModal from 'vue-js-modal';

// vue-js-modal の読み込み
Vue.use(VModal);

// App.vueをエントリとしてレンダリング
new Vue({
  el: '#app',
  render: h => h(App)
})
