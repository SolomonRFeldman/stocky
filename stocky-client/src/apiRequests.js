const configObj = (method) => {
  const obj = {
    method: method,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    }
  }
  return localStorage.token ? {...obj, headers: { ...obj.headers, "Token": localStorage.token }} : obj
}

export const getRequest = (url) => fetch(url, configObj("GET")).then(response => response.json())
const configObjWithBody = (method, body) => {
  return { ...configObj(method), body: JSON.stringify(body) }
}
export const postRequest = (url, body) => fetch(url, configObjWithBody("POST", body)).then(response => response.json())