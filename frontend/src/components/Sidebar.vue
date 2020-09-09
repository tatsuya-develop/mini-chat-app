<template>
  <div class="sidebar">
    <button class="addButton" v-on:click="show(register_modal_name)">+</button>
    <div class="chatGroupList">
      <div class="chatGroup" v-for="(chat_group, index) in _chat_groups" :key='index'>
        <div class="groupName">
          <span v-on:click="onSelectChatGroup(chat_group.id)" v-bind:value="selected_id">
            {{ chat_group.name }}
          </span>
        </div>
      </div>
    </div>
    <single-register-modal 
      :name="register_modal_name" 
      :title="register_modal_title"
      :input_text="input_text"
      :error_message="frontend_error_message"
      :hide="hide" 
      :parentRegister="register"
      @update:input_text="input_text = $event"
    ></single-register-modal>
    <ok-modal 
      :name="error_modal_name" 
      :hide="hide" 
      :message="backend_error_message"
    ></ok-modal>
  </div>
</template>

<script>
import axios from 'axios';
import Const from '../config/const.js';
import Message from '../config/message.js';
import SingleRegisterModal from './common/SingleRegisterModal.vue'
import OkModal from './common/OkModal.vue'

export default {
  components: {
    SingleRegisterModal,
    OkModal,
  },
  props: [
    'chat_groups',  // Array
    'selected_id',  // Integer
  ],
  data() {
    return {
      register_modal_name: Const.REGISTER_CHAT_GROUP_MODAL_NAME,
      register_modal_title: Const.REGISTER_CHAT_GROUP_MODAL_TITLE,
      error_modal_name: Const.ERROR_MODAL_NAME,
      backend_error_message: Message.BACKEND_ERROR.CREATE,
      frontend_error_message: '',
      input_text: '',
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
    }
  },
  methods: {
    // 選択されたチャットグループのIDに更新
    onSelectChatGroup: function (id) {
      this._selected_id = id;
    },
    // チャットグループの作成
    createChatGroup: function () {
      if (!this.input_text) {
        // this.frontend_error_message = Message.FRONTEND_ERROR.NO_INPUT;
        // return false;
      }
      const params = {
        chat_group: {
          name: this.input_text,
        }
      };
      axios.post(Const.API_URL + 'chat_groups', params)
        .then((response) => {
          this._chat_groups.push(response.data);
          this.onSelectChatGroup(response.data.id);
          this.input_text = '';
          this.hide(this.register_modal_name);
        })
        .catch((error) => {
          this.show(this.error_modal_name);
          console.error(error);
        });
    },
    // モーダルオープン時の処理
    show: function (target_modal_name) {
      this.$modal.show(target_modal_name);
    },
    // モーダルクローズ時の処理
    hide: function (target_modal_name) {
      this.$modal.hide(target_modal_name);
    },
    // モーダルアクション時の処理
    register: function (name) {
      const is_result = this.createChatGroup(name);
      if (is_result) {
        this.hide(this.register_modal_name);
        return true;
      }
      return false;
    },
  }
}
</script>

<style lang="css" scoped>
.sidebar {
  width: 19%;
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