import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { first } from 'rxjs/operators';
import { IAnswerHistory } from 'src/app/models/answer';
import { IFormRecordDetail } from 'src/app/models/form-record';
import { IListValue } from 'src/app/models/list-value';
import { IQuestion } from 'src/app/models/question';
import { FormRecordService } from 'src/app/services/form-record.service';
import { ListService } from 'src/app/services/list.service';
import { QuestionsService } from 'src/app/services/questions.service';

@Component({
	selector: 'app-history',
	templateUrl: './history.component.html',
	styleUrls: ['./history.component.scss']
})
export class HistoryComponent implements OnInit {

	formRecord: IFormRecordDetail;
	history: IAnswerHistory[] = [];
	questions: { [id: number]: IQuestion };
	options: { [id: number]: IListValue };

	constructor(
		private route: ActivatedRoute,
		private formRecordService: FormRecordService,
		private listService: ListService,
		private questionsService: QuestionsService
	) { }

	async ngOnInit(): Promise<void> {
		const paramMap = await this.route.paramMap.pipe(first()).toPromise();
		const formRecordID = parseInt(paramMap.get('formRecordID'), 10);
		this.formRecordService.getDetails(formRecordID).subscribe(details => this.formRecord = details);
		this.history = await this.formRecordService.getHistory(formRecordID).pipe(first()).toPromise();
		this.questions = await this.questionsService.getAll().pipe(first()).toPromise();
		this.options = await this.listService.getAllOptions().pipe(first()).toPromise();
		console.log(this.options);
	}

}
