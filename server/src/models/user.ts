export interface User {
    login: string;
    password: string;
    password_confirmation: string;
    firstName: string;
    lastName: string;
    eMail?: string;
    foneNumber?: string;
    regionalCouncilCode?: string;
}