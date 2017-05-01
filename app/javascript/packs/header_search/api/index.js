import axios from 'axios';

const consts = {
    SEARCH_PATH: '/search'
};

export function find(text) {
    return axios.get(consts.SEARCH_PATH, {params: {text}});
}