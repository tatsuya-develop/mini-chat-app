<template>
  <div class="app">
    <sidebar
      :chat_groups="chat_groups"
      :selected_id="selected_id"
      @update:chat_groups="chat_groups = $event"
      @update:selected_id="selected_id = $event"
    ></sidebar>
    <chat-container
      :selected_chat_group="selected_chat_group"
      :chat_groups="chat_groups"
      :removalSelectedChatGroup="removalSelectedChatGroup"
      @update:selected_chat_group="selected_chat_group = $event"
    ></chat-container>
  </div>
</template>

<script>
import Sidebar from './components/Sidebar.vue';
import ChatContainer from './components/ChatContainer.vue';
import axios from 'axios';
import Const from './config/const.js';

export default {
  components: {
    Sidebar,
    ChatContainer,
  },
  data() {
    return {
      selected_chat_group: {},
      chat_groups: [],
      selected_id: null,
    };
  },
  watch: {
    selected_chat_group: function(new_chat_group) {
      this.chat_groups = this.chat_groups.concat().reduce((acc, cur) => {
        if (new_chat_group && cur.id === new_chat_group.id) {
          cur.name = new_chat_group.name;
        }
        acc.push(cur);
        return acc;
      }, []);
    }
  },
  created: function() {
    this.getAllChatGroup();
  },
  updated: function() {
    const chat_group = this.chat_groups.filter((item) => {
      return item.id === this.selected_id;
    });
    this.selected_chat_group = chat_group[0];
  },
  methods: {
    // 全チャットグループの取得
    getAllChatGroup: function () {
      axios.get(Const.API_URL + 'chat_groups')
        .then((response) => {
          const chat_groups = response.data;
          this.chat_groups = chat_groups;
        })
        .catch((error) => {
          console.error(error.response.data.message);
        });
    },
    // 選択中のチャットグループを配列から削除し、選択状態も解除
    removalSelectedChatGroup: function (selected) {
      this.chat_groups = this.chat_groups.concat().filter((chat_group) => {
        return chat_group.id !== selected.id
      });
      this.selected_chat_group = null;
    },
  }
};
</script>

<style lang="css">
* {
  color: black;
}

html {
  height: 100%;
  width: 100%;
  min-height: 720px;
  background:linear-gradient(90deg,gray 0%,gray 20%,white 20%,white 100%);
}

body {
  margin: 5px;
  height: 100%;
  width: 100%;
}

.app {
  display: flex;
  height: 100%;
  width: 100%;
}

button {
  cursor: pointer;
  height: 36px;
  width: 100px;
  font-size: 14px;
}

.btn-primary {
  background: blue;
  color: white;
  border: none;
}

.btn-healthy {
  background: green;
  color: white;
  border: none;
}

.btn-healthy:disabled {
  background: gray;
  color: white;
  border: none;
  cursor: not-allowed;
}
</style>