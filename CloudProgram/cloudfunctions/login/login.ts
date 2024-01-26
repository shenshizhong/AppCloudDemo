
/**
 * 云函数入口
 * */

let myHandler = async function (event, context, callback, logger) {//event: 接收请求信息。 callback:返回服务器数据
  logger.info(event);

  // do something here
  let random = Math.random().toFixed(4);

  callback({ //返回服务器的数据
    code: 0,
    desc: "Success." + random
  });
};

export { myHandler };