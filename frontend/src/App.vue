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
    ChatContainer
  },
  data() {
    return {
      selected_chat_group: {},
      chat_groups: [],
      selected_id: null,
    };
  },
  created: function () {
    this.getAllChatGroup();
  },
  updated: function () {
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

          if (chat_groups.length > 0) {
            this.selected_id = chat_groups[0].id;
          }
        })
        .catch((error) => {
          console.error(error.response.data.message);
        });
    }
  }
};
</script>

<style lang="css">
body {
  background:linear-gradient(90deg,gray 0%,gray 20%,white 20%,white 100%);
  min-width: 1280px;
  min-height: 720px;
}

.app {
  display: flex;
}

button {
  cursor: pointer;
}
</style>