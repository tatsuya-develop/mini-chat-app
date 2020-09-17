export default Object.freeze({
  // バックエンドのエラーメッセージ
  BACKEND_ERROR: {
    CREATE: '登録処理に失敗しました',
    UPDATE: '更新処理に失敗しました',
    DELETE: '削除処理に失敗しました',
    INTERNAL_SERVER_ERROR: 'システム側でエラーが発生しました。管理者にご連絡ください。',
  },
  // フロントエンドのエラーメッセージ
  FRONTEND_ERROR: {
    NO_INPUT: '未入力の項目が存在します',
  },
  DELETE_CONFIRM_MESSAGE: '本当に削除してもよろしいですか？',
  PLEASE_SELECT_CHAT_GROUP_MESSAGE: 'サイドバーからチャットグループを選択してください。',
  PLEASE_CREATE_CHAT_GROUP_MESSAGE: 'チャットグループを作成してください。',
});