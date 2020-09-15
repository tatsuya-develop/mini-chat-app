<template>
  <div class="sidebar">
    <button class="addButton" v-on:click="showModal(register_modal_name)">+</button>
    <div class="chatGroupList">
      <div class="chatGroup" v-for="chat_group in _chat_groups" :key="chat_group.id">
        <div class="groupName">
          <span v-on:click="onSelectChatGroup(chat_group)" v-bind:value="selected_id">
            {{ chat_group.name }}
          </span>
        </div>
      </div>
    </div>
    <single-text-box-modal
      :name="register_modal_name" 
      :title="register_modal_title"
      :input_text="input_text"
      :button_submit="single_text_box_modal_button"
      :error_message="frontend_error_message"
      :hide="hideModal" 
      :parentSubmit="register"
      :resetErrorMessage="resetErrorMessage"
      @update:input_text="input_text = $event"
    ></single-text-box-modal>
    <ok-modal 
      :name="error_modal_name" 
      :hide="hideModal" 
      :message="backend_error_message"
      :message_detail="backend_error_message_detail"
    ></ok-modal>
  </div>
</template>

<script>
import axios from 'axios';
import Const from '../config/const.js';
import Message from '../config/message.js';
import SingleTextBoxModal from './common/SingleTextBoxModal.vue'
import OkModal from './common/OkModal.vue'
import Common from '../config/common.js'

export default {
  components: {
    SingleTextBoxModal,
    OkModal,
  },
  props: {
    'chat_groups': Array,
    'selected_id': Number,
  },
  data() {
    return {
      frontend_error_message: '',
      input_text: '',
      backend_error_message_detail: '',
    };
  },
  computed: {
    _chat_groups: {
      get: function() {
        return this.chat_groups;
      },
      set: function(value) {
        this.$emit('update:chat_groups', value);
      }
    },
    _selected_id: {
      get: function() {
        return this.selected_id;
      },
      set: function(value) {
        this.$emit('update:selected_id', value);
      }
    },
    register_modal_name: () => Const.REGISTER_CHAT_GROUP_MODAL_NAME,
    register_modal_title: () => Const.REGISTER_CHAT_GROUP_MODAL_TITLE,
    error_modal_name: () => Const.SIDEBAR_ERROR_MODAL_NAME,
    backend_error_message: () => Common.GENERATE_LENTICULAR_BRACKET(Message.BACKEND_ERROR.CREATE),
    single_text_box_modal_button: () => Const.REGISTER,
  },
  methods: {
    // 選択されたチャットグループのIDに更新
    onSelectChatGroup: function(chat_group) {
      this._selected_id = chat_group ? chat_group.id : null;
    },
    // チャットグループの作成
    createChatGroup: function() {
      // 未入力であるかをチェック
      if (!this.input_text) {
        this.frontend_error_message = Message.FRONTEND_ERROR.NO_INPUT;
        return false;
      }
      // パラメータ設定
      const params = {
        chat_group: {
          name: this.input_text,
        }
      };
      // チャットグループの登録
      axios.post(Const.API_URL + 'chat_groups', params)
        .then((response) => {
          // チャットグループリストに追加したチャットグループを追加し、選択
          const data = response.data;
          this._chat_groups.push(data);
          this.onSelectChatGroup(data);
          // 入力値の初期化と、入力モーダルを閉じる
          this.input_text = '';
          this.hideModal(this.register_modal_name);
        })
        .catch((error) => {
          this.showModal(this.error_modal_name);
          this.backend_error_message_detail = error.response.data.message;
          console.error(error.response.data);
        });
    },
    // モーダルオープン時の処理
    showModal: function(target_modal_name) {
      this.$modal.show(target_modal_name);
    },
    // モーダルクローズ時の処理
    hideModal: function(target_modal_name) {
      this.$modal.hide(target_modal_name);
    },
    // モーダルアクション時の処理
    register: function() {
      this.createChatGroup(this.input_text);
    },
    // front_error_message のリセット
    resetErrorMessage: function() {
      this.frontend_error_message = '';
    }
  }
}
</script>

<style lang="css" scoped>
.sidebar {
  width: 20%;
  padding: 1em;
}

.addButton {
  width: 25px;
  height: 25px;
  border-radius: 50%;
  background: gray;
  color: white;
  border-color: white;
  border-style: solid;
  border-width: thin;
}

.chatGroupList {
  padding: 10px 0;
}

.chatGroup {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
}

.groupName {
  width: 80%;
}

.groupName > span {
  color: white;
  cursor: pointer;
}

</style>