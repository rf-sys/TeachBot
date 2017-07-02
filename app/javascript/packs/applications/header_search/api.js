import {http} from './../../config';

const consts = {
  SEARCH_PATH: '/search'
};

export function find(text) {
  return http.get(consts.SEARCH_PATH, {params: {text}});
}