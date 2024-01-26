import agconnect from '@hw-agconnect/api-ohos';
import "@hw-agconnect/function-ohos";

import { Log } from '../common/Log';
import { getAGConnect } from './AgcConfig';

const TAG = "[AGCFunction]";

export function uuid(context): Promise<string> {
        return new Promise((resolve, reject) => {
            getAGConnect(context);
            let functionResult;
            let functionCallable = agconnect.function().wrap("idgenerator-$latest");
            functionCallable.call().then((ret: any) => {
                functionResult = ret.getValue();
                Log.info(TAG, "Cloud Function Called, Returned Value: " + JSON.stringify(ret.getValue()));
                resolve(functionResult.uuid);
            }).catch((error: any) => {
                Log.error(TAG, "Error - could not obtain cloud function result. Error Detail: " + JSON.stringify(error));
                reject(error);
            });
        });
}

export function login(context): Promise<string> {
    return new Promise((resolve, reject) => {
        getAGConnect(context);
        console.log("开始请求")
        let functionCallable = agconnect.function().wrap("login-$latest");
        functionCallable.call().then((ret: any) => {
            Log.info(TAG, "Cloud Function Called, 返回来的值: " + JSON.stringify(ret.getValue()));
            resolve(JSON.stringify(ret.getValue())); //这里会进行回调
        }).catch((error: any) => {
            Log.error(TAG, "Error - could not obtain cloud function result. Error Detail: " + JSON.stringify(error));
            reject(error);
        });
    });
}

export function createCloudDB(context): Promise<string> {
    return new Promise((resolve, reject) => {
        getAGConnect(context);
        console.log("开始请求")
        let functionCallable = agconnect.function().wrap("login-$latest");
        functionCallable.call().then((ret: any) => {
            Log.info(TAG, "Cloud Function Called, 返回来的值: " + JSON.stringify(ret.getValue()));
            resolve(JSON.stringify(ret.getValue())); //这里会进行回调
        }).catch((error: any) => {
            Log.error(TAG, "Error - could not obtain cloud function result. Error Detail: " + JSON.stringify(error));
            reject(error);
        });
    });
}