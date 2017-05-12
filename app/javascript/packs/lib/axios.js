import axios from 'axios';

/**
 * Configured axios instance
 * @type {AxiosInstance}
 */
export const http = axios.create({
    headers: {
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").getAttribute('content')
    },
});