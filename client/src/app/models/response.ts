export interface IResponse<T = any> {
    error: boolean;
    message?: string;
    data?: T;
}
