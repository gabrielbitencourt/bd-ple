import { Component, Input, OnInit } from '@angular/core';
import { MatCheckbox, MatCheckboxChange } from '@angular/material/checkbox';
import { MatDatepicker, MatDatepickerToggle } from '@angular/material/datepicker';
import { Observable } from 'rxjs';
import { first } from 'rxjs/operators';
import { IQuestionnaireAnswers } from 'src/app/models/questionnaire-answers';
import { FormRecordService } from 'src/app/services/form-record.service';
import { ListService } from 'src/app/services/list.service';

@Component({
	selector: 'app-question',
	templateUrl: './question.component.html',
	styleUrls: ['./question.component.scss']
})
export class QuestionComponent implements OnInit {

	@Input() question: IQuestionnaireAnswers;
	@Input() editMode: Observable<boolean>;

	constructor(private listService: ListService, private formRecordsService: FormRecordService) { }

	async ngOnInit(): Promise<void> {
		if (this.question.questionTypeID === 1 && typeof this.question.answer !== 'boolean') {
			if (this.question.answer === '1') this.question.answer = true;
			else if (this.question.answer === '0') this.question.answer = false;
			else this.question.answer = false;
		}
		else if (this.question.questionTypeID === 3 && typeof this.question.answer !== 'boolean') {
			if (this.question.answer === '0') this.question.answer = false;
		}
		else if (this.question.questionTypeID === 4 && !this.question.options) {
			this.question.options = await this.listService.getListOptions(this.question.listTypeID).pipe(first()).toPromise();
		}

		if (this.question.subordinateCount > 0) {
			this.question.subordinates = await this.formRecordsService
				.getAnswersFromParentQuestionInFormRecord(this.question.formRecordID, this.question.questionID)
				.pipe(first())
				.toPromise();
		}
	}

	openDatePicker(picker: MatDatepicker<any>): void {
		picker.open();
	}

	labAnswerChanged(event: Event, checkbox: MatCheckbox): void {
		if ((event.target as HTMLInputElement).value !== '') {
			checkbox.writeValue(false);
		}
	}

	notDoneChanged(event: MatCheckboxChange): void {
		if (event.checked) {
			this.question.answer = false;
		}
		else {
			this.question.answer = '';
		}
	}

	optionDescription(question: IQuestionnaireAnswers): string {
		if (question.options && question.listValueID) {
			const option = question.options.find(o => o.listOfValuesID == question.listValueID);
			return option ? option.description : undefined;
		}
	}

}
