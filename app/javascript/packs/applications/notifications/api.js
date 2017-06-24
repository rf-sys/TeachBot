import {http} from './../../lib/axios';

const paths = {
  ALL_NOTIFICATIONS: '/notifications?page=',
  UNREAD_NOTIFICATIONS_COUNT: '/notifications/count',
  CLEAR_UNREAD_NOTIFICATIONS_COUNT: '/notifications/mark_as_read'
};

/**
 * Load notifications
 * @param {number} page
 * @return {Promise}
 */
export function loadNotifications(page = 1) {
  return http.get(paths.ALL_NOTIFICATIONS + page);
}

/**
 * Load count of unread notifications
 * @return {Promise}
 */
export function loadUnreadNotificationsCount() {
  return http.post(paths.UNREAD_NOTIFICATIONS_COUNT);
}

/**
 * Clear unread notifications count (mark all as read)
 * @return {Promise}
 */
export function clearUnreadNotifications() {
  return http.put(paths.CLEAR_UNREAD_NOTIFICATIONS_COUNT);
}