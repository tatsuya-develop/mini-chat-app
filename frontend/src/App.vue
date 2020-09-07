<template>
  <div class="app">
    <sidebar></sidebar>
    <chat-container></chat-container>
  </div>
</template>

<script>
import Sidebar from './components/Sidebar.vue';
import ChatContainer from './components/ChatContainer.vue';

export default {
  components:{
    Sidebar,
    ChatContainer
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