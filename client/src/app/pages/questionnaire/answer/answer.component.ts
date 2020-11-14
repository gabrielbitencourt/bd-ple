import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { FormControl, Validators, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { first } from 'rxjs/operators';
import { IHospital } from 'src/app/models/hospital';
import { IModules } from 'src/app/models/form-record';
import { IParticipant } from 'src/app/models/participant';
import { FormRecordService } from 'src/app/services/form-record.service';
import { HospitalService } from 'src/app/services/hospital.service';
import { ModulesService } from 'src/app/services/modules.service';
import { ParticipantService } from 'src/app/services/participant.service';

@Component({
	selector: 'app-answer',
	templateUrl: './answer.component.html',
	styleUrls: ['./answer.component.scss']
})
export class AnswerComponent implements OnInit {

	@Input() participantID: number = null;
	@Input() hospitalID: number = null;

	@Output() created = new EventEmitter<any>();

	questionnaireID: number;
	hospitals: IHospital[] = [];
	participants: IParticipant[] = [];
	modules: IModules[] = [];

	participant = new FormControl(this.participantID, [
		Validators.required
	]);
	hospital = new FormControl(this.hospitalID, [
		Validators.required
	]);
	module = new FormControl('', [
		Validators.required
	]);

	createForm = new FormGroup({
		participant: this.participant,
		hospital: this.hospital,
		module: this.module
	});

	constructor(
		private hospitalService: HospitalService,
		private participantService: ParticipantService,
		private modulesService: ModulesService,
		private formRecordService: FormRecordService,
		private route: ActivatedRoute,
		private router: Router) { }

	async ngOnInit(): Promise<void> {
		const paramMap = await this.route.paramMap.pipe(first()).toPromise();
		this.questionnaireID = parseInt(paramMap.get('questionnaireID'), 10);

		this.participants = await this.participantService.getAll().pipe(first()).toPromise();
		this.hospitals = await this.hospitalService.getAll().pipe(first()).toPromise();
		this.modules = await this.modulesService.getAll(this.questionnaireID).pipe(first()).toPromise();
		if (this.participantID) {
			this.participant.setValue(this.participantID);
			this.participant.disable();
		}
		if (this.hospitalID) {
			this.hospital.setValue(this.hospitalID);
			this.hospital.disable();
		}
	}

	async createFormRecord(): Promise<void> {
		const res = await this.formRecordService.create(this.questionnaireID, this.module.value, this.participant.value, this.hospital.value)
			.pipe(first())
			.toPromise();
		if (!res.error) {
			this.created.emit(res.data);
			this.router.navigate(['questionnaire', this.questionnaireID, 'answers', this.hospital.value, this.participant.value]);
		}
	}

}
